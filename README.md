# Vagrant boilerplate

This project aims to cover best practices for usage Vagrant as a whole.

[The source for this project is available here][src]

Most of the configuration for project is done in the `Vagrantfile` file.
You should edit this file accordingly to adapt this boilerplate project
to your needs.

This is the README file for the project.

The file should use UTF-8 encoding and can be written using
[GitHub Flavored Markdown][md] with the appropriate key set.
It will be displayed as the project
homepage on common code-hosting services, and should be written for that
purpose.

Typical contents for this file would include an overview of the project, basic
usage examples, etc. Generally, including the project changelog in here is not a
good idea, although a simple "What's New" section for the most recent version
may be appropriate.

All tasks are performed from the project directory itself where placed
***Vagrantfile***.

## Display available boxes

To see which boxes are available we can run:

```bash
vagrant box list
```

## Update box

```bash
vagrant box update
```

## Run VM

```bash
vagrant up
```

## Destroy VM

```bash
vagrant destroy -f
```

## Display VM state

```bash
vagrant status
vagrant global-status
```

[src]: https://github.com/akman/vagrant-boilerplate
[md]: https://help.github.com/articles/basic-writing-and-formatting-syntax
