# stagex-demo

A quick-n-dirty demo that [stagex](https://codeberg.org/stagex/stagex) can be self-hosting.

Clone this repo next to your stagex clone. Then run `make run` to build a VM from stagex and run it, then `make ssh` to SSH into it.

Finally, you can rebuild stagex in the VM:
```
git clone https://codeberg.org/stagex/stagex.git /build/stagex
cd /build/stagex
make IMPORT=1 core-busybox ...
```

You can "install" software by extracting container contents:
```
make -C ../stagex IMPORT=1 user-mtools
mkdir /mnt
ctr -a /var/run/docker/containerd/containerd.sock -n moby \
  image mount docker.io/stagex/user-mtools:local /mnt
cp -a /mnt/* /
umount /mnt
```

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
