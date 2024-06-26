module Zohax
  require 'httparty'
  require 'json'
  require 'xmlsimple'

  class Crm
    include HTTParty

    def initialize(username, password, token = nil)
      @api = Zohax::Api.new(username, password, token)
    end

    def find_leads(queryParameters)
      @api.call('Leads', 'getRecords', queryParameters, :get)
    end

    def search_leads(searchConditions)
      @api.call('Leads', 'getSearchRecords', searchConditions, :get)
    end

    def add_lead(data)
      xmlData = parse_data(data, 'Leads')
      record = @api.call('Leads', 'insertRecords', {:xmlData => xmlData, :newFormat => 1}, :post)
      record['Id']
    end

    def update_lead(data, record_id)
      xmlData = parse_data(data, 'Leads')
      record = @api.call('Leads', 'updateRecords', {:xmlData => xmlData, :newFormat => 1, :id => record_id}, :post)
    end

    def remove_lead(id)
      @api.call('Leads', 'deleteRecords', {:id => id}, :get)
    end

    def get_lead_fields(type = nil)
      @api.call('Leads', 'getFields', {:type => type}, :get)
    end

    private

    def parse_data(data, entry)
      fl = data.map {|e| Hash['val', e[0], 'content', e[1]]}
      row = Hash['no', '1', 'FL', fl]
      data = Hash['row', row]
      XmlSimple.xml_out(data, :RootName => entry)    
    end
  end

end
