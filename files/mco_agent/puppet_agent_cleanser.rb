module MCollective
  module Agent
    class Puppet_agent_cleanser < RPC::Agent

      MAX_AGE = 3600

      def agent_catalog_run_lockfile
        cmd = '/opt/puppetlabs/puppet/bin/puppet apply --configprint agent_catalog_run_lockfile'
        out = ""
        err = ""
        code = run(cmd, :stdout => out, :stderr => err)
        unless code == 0
          raise "Error when running cmd: [#{cmd}], status: [#{code}], stderr: [#{err}], stdout: [#{out}]"
        end
        out.chomp
      end

      def has_stale_lockfile
        lockfile = agent_catalog_run_lockfile
        return false unless File.exist?(lockfile)
        age = Time.now - File.mtime(lockfile)
        return false if age < MAX_AGE
        return age
      end

      def agent_processes
        cmd = '/usr/bin/pgrep -fl "puppet agent"'
        out = ""
        err = ""
        code = run(cmd, :stdout => out, :stderr => err)
        unless [0, 1].include?(code)
          raise "Error when running cmd: [#{cmd}], status: [#{code}], stderr: [#{err}], stdout: [#{out}]"
        end
        pgrep = out.chomp.split
      end

      def kill_agent_processes(signal = 'SIGTERM')
        cmd = "/usr/bin/pkill -#{signal} -f 'puppet agent'"
        out = ""
        err = ""
        code = run(cmd, :stdout => out, :stderr => err)
        unless [0, 1].include?(code)
          raise "Error when running cmd: [#{cmd}], status: [#{code}], stderr: [#{err}], stdout: [#{out}]"
        end
        pkill = out.chomp.split
      end

      def status
        age = has_stale_lockfile
        return age
      end

      def cleanse
        #   if agent service running
        #     stop agent
        #   if any puppet agent processes still running
        #     kill them
        #   if lockfile exists
        #     rm it
        #   start agent
        age = has_stale_lockfile

        cmd = '/opt/puppetlabs/puppet/bin/puppet resource service puppet ensure=stopped'
        out = ""
        err = ""
        code = run(cmd, :stdout => out, :stderr => err)
        unless code == 0
          raise "Error when running cmd: [#{cmd}], status: [#{code}], stderr: [#{err}], stdout: [#{out}]"
        end

        if agent_processes.length > 0
          kill_agent_processes
          sleep 10
        end

        if agent_processes.length > 0
          kill_agent_processes('SIGKILL')
          sleep 10
        end

        if agent_processes.length > 0
          raise "Unable to kill puppet agents! Still have the following: #{agent_processes.inspect}"
        end

        lockfile = agent_catalog_run_lockfile
        if File.exist?(lockfile)
          File.delete(lockfile)
        end

        cmd = '/opt/puppetlabs/puppet/bin/puppet resource service puppet ensure=running'
        out = ""
        err = ""
        code = run(cmd, :stdout => out, :stderr => err)
        unless code == 0
          raise "Error when running cmd: [#{cmd}], status: [#{code}], stderr: [#{err}], stdout: [#{out}]"
        end

        "success"
      end

      action "status" do
        reply[:status] = status
      end

      action "cleanse" do
        reply[:results] = cleanse
      end
    end
  end
end

