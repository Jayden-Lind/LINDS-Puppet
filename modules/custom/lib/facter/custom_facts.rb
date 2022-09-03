Facter.add(:host_code) do
    setcode do
      Facter.value(:hostname).split("-").first().downcase
    end
  end
  Facter.add(:application) do
    setcode do
      Facter.value(:hostname).split("-")[1].downcase
    end
  end