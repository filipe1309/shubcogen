# <p align="center">[WIP] ShubcoGen 💀</p>

<p align="center">
    <img src="https://img.shields.io/badge/php-8.0-green" alt="PHP"/>
    <img src="https://img.shields.io/badge/lumen-8.0-orange" alt="Lumen"/>
    <img src="https://img.shields.io/badge/nodejs-15.0-green" alt="NodeJS"/>
    <hr>
    <img src="https://img.shields.io/badge/Code-Go-informational?style=flat-square&logo=go&color=00ADD8" alt="Go" />
    <img src="https://img.shields.io/badge/Code-PHP-informational?style=flat-square&logo=php&color=777bb4&logoColor=8892BF" alt="PHP" />
    <img src="https://img.shields.io/badge/Code-Laravel-informational?style=flat-square&logo=laravel&color=FF2D20" alt="Laravel" />
    <img src="https://img.shields.io/badge/Code-Lumen-informational?style=flat-square&logo=lumen&color=F4645F" alt="Lumen" />
    <img src="https://img.shields.io/badge/Code-JavaScript-informational?style=flat-square&logo=javascript&color=F7DF1E" alt="JavaScript" />
    <img src="https://img.shields.io/badge/Code-NodeJS-informational?style=flat-square&logo=node.js&color=339933" alt="NodeJS" />
    <img src="https://img.shields.io/badge/Tools-Docker-informational?style=flat-square&logo=docker&color=2496ED" alt="Docker" />
    <img src="https://img.shields.io/badge/Tools-MySQL-informational?style=flat-square&logo=mysql&color=4479A1&logoColor=2496ED" alt="MySQL" />
    <img src="https://img.shields.io/badge/Tools-SQLServer-informational?style=flat-square&logo=microsoft-sql-server&color=CC2927&logoColor=CC2927" alt="SQLServer" />
</p>
    <hr>

## 💬 About

**S**keleton Git**Hub** **Co**urse **Generator**.

This project aims to be a skeleton generator for course projects deployed on GitHub.

### Components that are generated:

- [x] `README.md`
- [x] `notes.md`
- [x] Deploy script (optional) with auto create tag, auto commit to `notes.md` files & deploy on GitHub
- [x] Pre-push script (optional)
- [x] Docker scripts & images (optional)

## :computer: Technologies

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Shell Script](https://www.shellscript.sh/)

## Get basic files

```sh
curl https://raw.githubusercontent.com/filipe1309/skeleton-courses/main/bin/get.sh | sh
```

## :scroll: Requirements

- [Docker](https://www.docker.com/)

## :cd: Installation

```sh
git clone git@github.com:filipe1309/skeleton-courses.git
```

```sh
cd skeleton-courses
```

## :runner: Generating the skeleton to your project [WIP]

```sh
./bin/generate.sh
```

Then copy the file on `gen` folder into yout project root folder.

## :pushpin: Roadmap

- [ ] Auto-update (optional) `deploy.sh`
- [ ] Add sementic versioning
- [ ] Add as a npm package & php package
- [ ] Backup os existing files
- [ ] Improve gitignore files (get from `https://github.com/github/gitignore`)
- [ ] Add badges generation
- [ ] Add color deploy script
- [ ] Improve project setup `bin/generate.sh` (with 2 types: `Class` or `Episode`, or another type set by user)
- [ ] Add an visual interface to create the `README.md` & setup project configs
- [ ] Simplify deploy script
- [ ] Add an option to append an extra script to `deploy.sh` (like a `changelog.sh`)

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)

## About Me

<p align="center">
    <a style="font-weight: bold" href="https://www.linkedin.com/in/filipe1309/">
    <img style="border-radius:50%" width="100px; "src="https://avatars.githubusercontent.com/u/2081014?s=60&v=4"/>
    </a>
</p>

---

<p align="center">
    Done with ♥ by <a style="font-weight: bold" href="https://www.linkedin.com/in/filipe1309/">Filipe Leuch Bonfim</a> 🖖
</p>
