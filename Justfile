deploy:
	make -j $(nproc) -C ~/Development/barebox/
	LOADER_2ND_PATH=~/Development/barebox/images/barebox-milkv-duo-s.img make -C fsbl 
	usbsdmux /dev/usb-sd-mux/id-00048.00239 host
	until [ -f /run/media/karlk/boot/fip.bin ]; do sleep 0.1; done
	cp fsbl/build/cv181x/fip.bin /run/media/karlk/boot/fip.bin
	sync
	usbsdmux /dev/usb-sd-mux/id-00048.00239 dut
	uhubctl -l 1-1.3 -p 4 -a cycle -S

deploy-uboot:
	./build.sh milkv-duos-sd
	usbsdmux /dev/usb-sd-mux/id-00048.00239 host
	until [ -f /run/media/karlk/boot/fip.bin ]; do sleep 0.1; done
	cp fsbl/build/cv1813h_milkv_duos_sd/fip.bin /run/media/karlk/boot/fip.bin
	sync
	usbsdmux /dev/usb-sd-mux/id-00048.00239 dut
	uhubctl -l 1-1.3 -p 4 -a cycle -S
