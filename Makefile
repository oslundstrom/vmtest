$$(basename $$(pwd)): transpiled_config.ign fedora.qcow2
	./install $$(basename $$(pwd)) *.qcow2 transpiled_config.ign
	virsh dumpxml $$(basename $$(pwd)) > $$(basename $$(pwd)).xml
transpiled_config.ign: my_config.bu
	podman pull quay.io/coreos/butane:release
	podman run --interactive --rm quay.io/coreos/butane:release \
       --pretty --strict < my_config.bu > transpiled_config.ign
my_config.bu: .venv/bin/activate
	. .venv/bin/activate
	cat ~/.ssh/id_rsa.pub | python3 jinja_apply.py my_config.j2 > my_config.bu
.venv/bin/activate:
	python3 -m venv .venv
	. .venv/bin/activate
	pip3 install jinja2

fedora.qcow2:
	wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/39.20231119.3.0/x86_64/fedora-coreos-39.20231119.3.0-qemu.x86_64.qcow2.xz -O fedora.qcow2
clean:
	virsh destroy $$(basename $$(pwd)) || true
	virsh undefine --nvram $$(basename $$(pwd)) || true
	rm $$(basename $$(pwd)).xml || true
	rm my_config.bu || true
	sudo rm transpiled_config.ign /var/lib/libvirt/images/$$(basename $$(pwd)).qcow2


