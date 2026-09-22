# homebrew-tap

Homebrew formulae for 여명거리's products.

```sh
brew tap yeomyeonggeori/tap
brew install internkim
```

On a Mac with Homebrew, the one line reaches the same place:

```sh
curl -fsSL https://intern.kim/install.sh | sh -s -- host
```

## What is in here

| Formula | What it installs |
| --- | --- |
| `internkim` | The company host: the agent, the messenger, the web app and the databases' client, for a computer that stays on |

Installing delivers the programs and starts nothing. The machine becomes a host
when it is given a company, which is the step that needs administrator rights:

```sh
sudo internkim install ~/Downloads/internkim-host.json
```

## Where the formula comes from

`Formula/internkim.rb` is rendered by `internkim release brew` from the product's
own source, so the `depends_on` lines here and the Debian package's `Depends:`
come from one declaration. A hand edit here is a second declaration of the same
list; change it at the source and cut a release. The bottles it points at are
served from `updates.intern.kim/brew`.
