module MCollective
  module Agent
    class Puppet_agent_cleanser < RPC::Agent

      MAX_AGE = 3600

      def agent_catalog_run_lockfile
        cmd = 'puppet agent --configprint agent_catalog_run_lockfile'
        reply[:status] = run(cmd, :stdout => :out, :stderr => :err)
        unless reply[:status] == 0
          raise "Error when running cmd: [#{cmd}], status: [#{reply[:status]}], stderr: [#{reply[:err]}], stdout: [#{reply[:out]}]"
        end
        reply[:out]
      end

      def has_stale_lockfile
        lockfile = agent_catalog_run_lockfile
        return false unless File.exist?(lockfile)
        age = Time.now - File.mtime(lockfile)
        return false if age > MAX_AGE
        return age
      end

      def agent_processes
        cmd = '/usr/bin/pgrep -fl "puppet agent"'
        result[:status] = run(cmd, :stdout => :out, :stderr => :err)
        unless result[:status] == 0
          raise "Error when running cmd: [#{cmd}], status: [#{result[:status]}], stderr: [#{result[:err]}], stdout: [#{result[:out]}]"
        end
        pgrep = result[:out].chomp.split
      end

      def kill_agent_processes(signal)
        signal = 'SIGTERM' unless signal
        cmd = "/usr/bin/pkill -#{signal} -f 'puppet agent'"
        result[:status] = run(cmd, :stdout => :out, :stderr => :err)
        unless result[:status] == 0
          raise "Error when running cmd: [#{cmd}], status: [#{result[:status]}], stderr: [#{result[:err]}], stdout: [#{result[:out]}]"
        end
        pkill = result[:out].chomp.split
      end

      def status
        age = has_stale_lockfile
        return age
      end

      def cleanse
        # if agent catalog run lockfile exists and age > max_age
        #   if agent service running
        #     stop agent
        #   if any puppet agent processes still running
        #     kill them
        #   if lockfile still exists
        #     rm it
        #   start agent
        age = has_stale_lockfile
        return false unless age

        cmd = 'puppet service puppet ensure=stopped'
        result[:status] = run(cmd, :stdout => :out, :stderr => :err)
        unless result[:status] == 0
          raise "Error when running cmd: [#{cmd}], status: [#{result[:status]}], stderr: [#{result[:err]}], stdout: [#{result[:out]}]"
        end

        if agent_processes.length > 0
          kill_agent_processes
          sleep 5
        end

        if agent_processes.length > 0
          kill_agent_processes('SIGKILL')
          sleep 5
        end

        if agent_processes.length > 0
          raise "Unable to kill puppet agents! Still have the following: #{agent_processes.inspect}"
        end

        lockfile = agent_catalog_run_lockfile
        if File.exist?(lockfile)
          File.delete(lockfile)
        end

        cmd = 'puppet service puppet ensure=running'
        result[:status] = run(cmd, :stdout => :out, :stderr => :err)
        unless result[:status] == 0
          raise "Error when running cmd: [#{cmd}], status: [#{result[:status]}], stderr: [#{result[:err]}], stdout: [#{result[:out]}]"
        end

        "success"
      end

      action "status" do
        reply[:status] = status
      end

      action "cleanse" do
        reply[:results] = "Not implemented"
      end
    end
  end
end

