module MCollective
  module Agent
    class PuppetAgentCleaner < RPC::Agent
      # Basic echo server
      action "clean" do
        reply[:msg] = request[:msg]
      end
    end
  end
end

