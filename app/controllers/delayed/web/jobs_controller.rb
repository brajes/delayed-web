module Delayed
  module Web
    class JobsController < Delayed::Web::ApplicationController
      def show
        if job == nil
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.executed')
          redirect_to jobs_path
        end
      end

      def queue
        if job.can_queue?
          job.queue!
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.queued')
        else
          flash[:alert] = t(:alert, scope: 'delayed/web.flashes.jobs.queued', status: job.status)
        end
        redirect_to jobs_path
      end

      def destroy
        if job.can_destroy?
          job.destroy
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.destroyed')
        else
          flash[:alert] = t(:alert, scope: 'delayed/web.flashes.jobs.destroyed', status: job.status)
        end
        redirect_to jobs_path
      end

    private

      def job
        @job ||= Delayed::Web::Job.find params[:id]
      end
      helper_method :job

      def jobs(state=nil, page=nil, per=10)
        case state.to_s.downcase
        when "queued"
          @jobs ||= Delayed::Job.page(page).per(per)
        when "executing"
          @jobs ||= Delayed::Job.where(:locked_at => { "$ne" => nil }, :locked_by => { "$ne" => nil } ).page(page).per(per)
        when "failed"
          @jobs ||= Delayed::Job.where(:failed => { "$ne" => nil }).page(page).per(per)
        else
          @jobs ||= Delayed::Job.page(page).per(per)
        end
      end
      helper_method :jobs
    end
  end
end
