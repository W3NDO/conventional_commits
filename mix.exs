defmodule ConventionalCommits.MixProject do
  use Mix.Project

  def project do
    [
      app: :conventional_commits,
      version: "0.2.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "mix task for writing conventional commits",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/W3NDO/conventional_commits"},
      source_url: "https://github.com/W3NDO/conventional_commits"
    ]
  end
end
