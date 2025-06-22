all: out/disk.img

out/keys:
	mkdir -p out
	ssh-add -L > "$@"

out/boot.img out/root.img: deps Makefile Dockerfile out/keys rcS
	docker build . --output type=local,dest=out

out/build.qcow2:
	qemu-img create -f qcow2 "$@" 100g

deps:
	# Build any deps from our Dockerfile
	make -C ../stagex IMPORT=1 $(shell  grep -Po '(?<=stagex/)[^:]+' Dockerfile | sort | uniq)

run: out/boot.img out/root.img out/build.qcow2
	qemu-system-x86_64 -accel kvm -m 16G -smp "$$(nproc)" \
		-net nic,model=virtio -net user,hostfwd=tcp::2222-:22 \
		-drive file=out/boot.img,format=raw \
		-drive file=out/root.img,format=raw \
		-drive file=out/build.qcow2

ssh:
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
		-p 2222 root@localhost

.PHONY: all deps run ssh
