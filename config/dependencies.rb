class DependenciesContainer
  extend Dry::Container::Mixin

  register "ipfs" do
    Ipfs::Gateway.new
  end
end

Dependencies = Dry::AutoInject(DependenciesContainer)
