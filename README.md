# <p align="center">WIP | ShubcoGen™ 💀</p>

<p align="center">
    <img src="https://img.shields.io/badge/Code-ShellScript-informational?style=flat-square&logo=gnubash&color=4EAA25" alt="ShellScript" />
</p>

<hr>

## 💬 About

**S**keleton Git**Hub** **Co**urse **Generator**.

This project aims to be a skeleton generator for course projects deployed on GitHub.

### Components that are generated:

- [x] `README.md`
- [x] `notes.md`
- [x] Deploy script (optional) with auto create tag, auto commit to `notes.md` files & deploy on GitHub
- [x] Self-Update script
- [x] Docker scripts & images (optional)

## :computer: Technologies

- [Curl](https://curl.se/)
- [Shell Script](https://www.shellscript.sh/)

## :scroll: Requirements

- [Git](https://git-scm.com/)
- [Curl](https://curl.se/)
- [Bash](https://www.gnu.org/software/bash/)

## 🕹 Usage

### 1. Create you project in GitHub

### 2. Get basic files

In you project directory, run:

```sh
curl https://raw.githubusercontent.com/filipe1309/shubcogen/main/.shub/bin/get.sh | sh
```

### 3. Generating the skeleton to your project

After running the script from step 2, you'll be prompted to choose the configs of your project. Don't worry, you can always change the configs later at `shub-config.json`.

> ⚠ Important: You'll be prompt to enter a couse type (`class`, `episode`, etc), and after that to initialize a new branch base on the course type. If you choose so, you'll be able to use the deploy script, and automate tag creation, commit to `notes.md` files and deploy on GitHub (see the section below).

### 4. Deploying into GitHub (optional)

You can deploy using the `shub-deploy.sh` script. This script auto-increments the version number of the branch and creates a new tag from branch name.

So you must be in a branch with a number at the end, like `my-branch-1` or `my-branch-1.1`.

For example, if your actual branch is `my-branch-1.1`, after running this script, the steps below will be performed:

1. A new tag `my-branch-1.1-some-description` will be created
2. The actual branch will be automatically merged into `main`
3. The `main` branch will be sent to GitHub with the new tag (with `git push && git push --tags`)
4. A new branch `my-branch-1.2` will be created
5. `notes.md` will be update with the new "version number"

```sh
./shub-deploy.sh
```

## :pushpin: Roadmap

- [x] Add sementic versioning
- [x] Add versioning into templates file
- [ ] Add as a global npm package & php package
- [x] Backup existing files
- [ ] Improve gitignore files (get from `https://github.com/github/gitignore`)
- [ ] Add badges generation
- [x] Add color deploy script
- [x] Improve project setup `bin/generate.sh` (with 2 types: `Class` or `Episode`, or another type set by user)
- [ ] Add an visual interface to create the `README.md` & setup project configs
- [ ] Simplify deploy script
- [ ] Add an option to append an extra script to `deploy.sh` (like a `changelog.sh`)
- [ ] Save deploy state (if an error occurs)
- [ ] Add tests (with [Bat](https://github.com/bats-core/bats-core))

## :octocat: Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Push from your terminal to active auto-versioning & auto-tagging (from `pre-push` git hook).

Push with `deploy.sh` script.

### :cd: Installation

```sh
git clone https://github.com/filipe1309/shubcogen.git
```

```sh
cd shubcogen
```

```sh
cp bin/pre-push .git/hooks/pre-push
```

### :white_check_mark: Tests


```sh
./test/bats/bin/bats test/test.bats
```

## License

[MIT](https://choosealicense.com/licenses/mit/)

## About Me

<p align="center">
    <a style="font-weight: bold" href="https://www.linkedin.com/in/filipe1309/">
    <img style="border-radius:50%" width="100px; "src="https://github.com/filipe1309.png"/>
    </a>
</p>

---

<p align="center">
    Done with ♥ by <a style="font-weight: bold" href="https://www.linkedin.com/in/filipe1309/">Filipe Leuch Bonfim</a> 🖖
</p>
