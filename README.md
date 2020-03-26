# Vagrant boilerplate

[![License](https://img.shields.io/github/license/akman/vagrant-boilerplate.svg)](https://github.com/akman/vagrant-boilerplate/blob/master/LICENSE)

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
vagrant box prune
```

## Start VM

```bash
vagrant up
```

## Stop VM

Halting the virtual machine by calling vagrant halt will gracefully shut down
the guest operating system and power down the guest machine.
You can use vagrant up when you are ready to boot it again.
The benefit of this method is that it will cleanly shut down your machine,
preserving the contents of disk, and allowing it to be cleanly started again.
The downside is that it'll take some extra time to start from a cold boot,
and the guest machine still consumes disk space.

```bash
vagrant halt
```

Suspending the virtual machine by calling vagrant suspend will save the current
running state of the machine and stop it. When you are ready to begin working
again, just run vagrant up, and it will be resumed from where you left off.
The main benefit of this method is that it is super fast, usually taking
only 5 to 10 seconds to stop and start your work. The downside is that
the virtual machine still eats up your disk space, and requires even more disk
space to store all the state of the virtual machine RAM on disk.

```bash
vagrant suspend
```

## Destroy VM

```bash
vagrant destroy -f
```

## Display VM state

```bash
vagrant status
vagrant global-status
vagrant global-status --prune
```

[src]: https://github.com/akman/vagrant-boilerplate
[md]: https://help.github.com/articles/basic-writing-and-formatting-syntax
