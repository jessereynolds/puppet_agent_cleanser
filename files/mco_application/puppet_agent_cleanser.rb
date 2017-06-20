class MCollective::Application::Puppet_agent_cleanser < MCollective::Application
  description "Cleanse the run state of your Puppet agents"

  def post_option_parser(configuration)
    if ARGV.length >= 1
      configuration[:command] = ARGV.shift

      unless ["status", "cleanse"].include?(configuration[:command])
        raise "Unknown command"
      end
    else
      raise "No command found"
    end
  end

  def status_command
    mc = rpcclient("puppet_agent_cleanser")
    printrpc mc.status()
    printrpcstats
  end

  def cleanse_command
    mc = rpcclient("puppet_agent_cleanser")
    printrpc mc.cleanse()
    printrpcstats
  end

  def main
    impl_method = "%s_command" % configuration[:command]

    if respond_to?(impl_method)
      send(impl_method)
    else
      raise_message(6, configuration[:command])
    end
  end

end

