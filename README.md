# stagex-boot

A quick-n-dirty demo that [stagex](https://codeberg.org/stagex/stagex) can be self-hosting.

Just clone this repo, then run `make run` to build a VM from stagex and run it, then `make ssh` to SSH into it.


You can "install" stagex packages by extracting container contents:

```
cd /build/stagex
make IMPORT=1 user-mtools
mkdir /mnt
ctr -a /var/run/docker/containerd/containerd.sock -n moby \
  image mount docker.io/stagex/user-mtools:local /mnt
cp -a /mnt/* /
umount /mnt
```

It's even self-hosting! You can rebuild stagex in the VM:

```
git clone https://codeberg.org/stagex/stagex.git /build/stagex
cd /build/stagex
make IMPORT=1 core-busybox ...
```

Last tested with [stagex commit 9212430f](https://codeberg.org/stagex/stagex/commit/9212430fe969dea75e67b916794299c12402efe3).

# Bootstrapping

You can also use this to bootstrap an entire bootable "distro" from scratch, using stagex.

First, you'll need to [setup Docker to use containerd](https://docs.docker.com/engine/storage/containerd/#enable-containerd-image-store-on-docker-engine). You should also prune any stagex images you already have locally.

Then clone this repo next to a clone of stagex, and run `make bootstrap` to build and run from scratch!

# License

(C) 2025 Dave Vasilevsky

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
