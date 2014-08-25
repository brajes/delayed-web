module Delayed
  module Web
    class Job::Mongoid
      def self.find *args
        decorate Delayed::Job.find(*args)
      end
      
      def self.where *args
        jobs = Delayed::Job.page(1).per(5).where(*args).entries
        jobs
        #Enumerator.new do |enumerator|
        #  jobs.each do |job|
        #    enumerator.yield decorate(job)
        #  end
        #end
      end

      def self.all
        jobs = Delayed::Job.desc('id')
        #Enumerator.new do |enumerator|
        #  jobs.each do |job|
        #    enumerator.yield decorate(job)
        #  end
        #end
      end

      def self.decorate job
        job = StatusDecorator.new job
        job = MongoidDecorator.new job
        job
      end
    end
  end
end
