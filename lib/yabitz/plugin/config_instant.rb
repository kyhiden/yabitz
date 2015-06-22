# -*- coding: utf-8 -*-
require 'json'
module Yabitz::Plugin
  module InstantConfig
    def self.plugin_type
      :config
    end
    def self.plugin_priority
      1
    end

    def self.extra_load_path(env)
      if env == :production
        ['~/Documents/Stratum']
      else
        ['~/Documents/Stratum']
      end
    end

    DB_PARAMS = [:server, :user, :pass, :name, :port, :sock]
    mysql_dbs = JSON.parse(ENV['VCAP_SERVICES'])
    CONFIG_SET = {
      :database => {
        :server => mysql_dbs["p-mysql"][0]["credentials"]["hostname"],
        :user => mysql_dbs["p-mysql"][0]["credentials"]["username"],
        :pass => mysql_dbs["p-mysql"][0]["credentials"]["password"],
        :name => mysql_dbs["p-mysql"][0]["credentials"]["name"],
        :port => mysql_dbs["p-mysql"][0]["credentials"]["port"],
        :sock => nil,
      },
      :test_database => {
        :server => 'localhost',
        :user => 'root',
        :pass => nil,
        :name => 'yabitztest',
        :port => nil,
        :sock => nil,
      },
    }

    def self.dbparams(env)
      if env == :test
        DB_PARAMS.map{|sym| CONFIG_SET[:test_database][sym]}
      else
        DB_PARAMS.map{|sym| CONFIG_SET[:database][sym]}
      end
    end
  end
end
