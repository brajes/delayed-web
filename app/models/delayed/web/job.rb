require 'forwardable'
require 'kaminari'

module Delayed
  module Web
    class Job
      extend SingleForwardable

      def_delegator :backend, :all
      def_delegator :backend, :where
      def_delegator :backend, :find

      # Set the backend you're using for Delayed::Job.
      #
      # Example:
      #   Delayed::Web::Job.backend = :active_record
      #
      # @param new_backend [String] "active_record" or "double".
      #
      # @return [void]
      def self.backend= new_backend
        @backend = "Delayed::Web::Job::#{new_backend.classify}".constantize
        
        if @backend == Delayed::Web::Job::Mongoid
          Delayed::Job.send(:include, Kaminari::MongoidExtension::Document)
        end
      end

      def self.backend
        @backend
      end
      
      def self.main_app_path
        @main_app_path
      end
      
      def self.main_app_path= new_main_app_path
        @main_app_path = new_main_app_path
      end
      
    end
  end
end
