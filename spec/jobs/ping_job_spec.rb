require "rails_helper"

RSpec.describe PingJob, type: :job do
  xit "works" do
    described_class.new.perform "https://ipfs.io/ipfs/QmPB33UEb3YuwDT7YYf4tUKA9ocmRJaigDxJgahe7gATyi"
  end
end
