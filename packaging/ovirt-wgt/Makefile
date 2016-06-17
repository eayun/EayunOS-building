repo = ovirt-wgt
package = ovirt-wgt
version = 0.103
ISO_IMAGE=oVirt-toolsSetup_$(version).iso

sources:
	cd ../../ ;\
		git submodule init packaging/$(repo)/upstream ;\
		git submodule update packaging/$(repo)/upstream ;\
	cd packaging/$(repo)/upstream ;\
	git reset --hard 85a16afa8dae368ce0745f4d5885b0b268a115bb; \
	git config user.name "Qili Lin" ;\
	git config user.email "qili.lin@eayun.com" ;\
	cd ..; \
	cp -r bin/ drivers/ upstream/
	for file in *.patch; do \
		if [ -f $$file ]; then \
			cd upstream; \
			git am ../$$file; \
			cd ..; \
		fi; \
	done; \
	cd upstream; \
	make iso; \
	cp $(ISO_IMAGE) ../
