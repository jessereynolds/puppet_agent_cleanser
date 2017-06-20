class MCollective::Application::PuppetAgentCleanser < MCollective::Application
   description "Cleanse the run state of your Puppet agents"

   def main
      mc = rpcclient("puppet_agent_cleanser")

      printrpc mc.echo(:msg => configuration[:message], :options => options)

      printrpcstats
   end
end

