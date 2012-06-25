$: << 'lib'

uri = ENV.fetch('ES_URI','http://localhost:9200')

require 'logger'
require 'veritas-elasticsearch-adapter'

logger = Logger.new($stdout)

adapter = Veritas::Adapter::Elasticsearch.new(uri,:logger => logger)

base_relation = Veritas::Relation::Base.new('test/people',
  [
    [:firstname,String],
    [:lastname,String]
  ]
)

index = 'test'

connection = adapter.send(:driver)

connection.drop(index)

connection.setup(index,
  :settings => {
    :number_of_shards => 1,
    :number_of_replicas => 0,
  },
  :mappings => {
    :people => {
      :properties => {
        :firstname => {
          :type => :multi_field,
          :fields => {
            :firstname => { :type => :string, :index => :not_analyzed },
            :search_firstname => { :type => :string, :index => :analyzed }
          }
        },
        :lastname => {
          :type => :multi_field,
          :fields => {
            :lastname => { :type => :string, :index => :not_analyzed },
            :search_lastname => { :type => :string, :index => :analyzed }
          }
        }
      }
    }
  }
)

connection.wait(index,:timeout => 10)

def add(connection,data)
  connection.send(:connection).post('test/people') do |request|
    request.options[:expect_status]=201
    request.options[:convert_json]=true
    request.body = data
  end
end

add(connection,:firstname => 'John',:lastname => 'Doe')
add(connection,:firstname => 'Sue',:lastname => 'Doe')

# Sync.
connection.refresh


gateway_relation = Veritas::Adapter::Elasticsearch::Gateway.new(adapter,base_relation) #.restrict { |r| r.lastname.eq("Doe").and(r.firstname.include(["John"])) }

require 'pp'

data = gateway_relation.map(&:to_ary)
pp data
