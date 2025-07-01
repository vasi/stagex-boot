BOOTSTRAP ?= no
STAGEX_DIR = ../stagex
QEMU_PORT = 2222

STAGEX_PACKAGES := $(shell grep -Po '(?<=stagex/)[^:]+' Dockerfile.in | sort | uniq)

all: out/boot.img out/root.img

out/keys:
	mkdir -p out
	ssh-add -L > "$@"

Dockerfile: Dockerfile.in
ifeq ($(BOOTSTRAP),no)
# Remove :local tags, so we just fetch the remote images
	sed -e 's/:local//' $< > $@
else
# Use IMPORT mode, so stagex tags each container as a :local image
	$(MAKE) -C $(STAGEX_DIR) IMPORT=1 $(STAGEX_PACKAGES)
	cp $< $@
endif

out/%.img: Makefile Dockerfile out/keys rcS
	docker build . --output type=local,dest=out --target $*.img
	touch $@

out/build.qcow2:
	qemu-img create -f qcow2 "$@" 100g

run: out/boot.img out/root.img out/build.qcow2
	qemu-system-x86_64 -accel kvm -m 16G -smp "$$(nproc)" \
		-net nic,model=virtio -net user,hostfwd=tcp::$(QEMU_PORT)-:22 \
		-drive file=out/boot.img,format=raw \
		-drive file=out/root.img,format=raw \
		-drive file=out/build.qcow2

ssh:
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
		-p 2222 root@localhost

clean:
	rm -rf Dockerfile out

bootstrap:
	$(MAKE) BOOTSTRAP=1 run

.PHONY: all run ssh clean bootstrap
