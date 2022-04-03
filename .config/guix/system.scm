;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules
  ;; (base-system)
  (gnu)
  (gnu system nss)

  (gnu services)
  (gnu services desktop)
  (gnu services xorg)
  (gnu services sound)
  (gnu services networking)
  (gnu services virtualization)
  (gnu services file-sharing)

  (gnu packages lisp)
  (gnu packages lisp-xyz)
  (gnu packages emacs)
  (gnu packages terminals)
  (gnu packages certs)
  (gnu packages xdisorg)
  (gnu packages vim)
  (gnu packages base)
  (gnu packages bash)
  (gnu packages java)
  (gnu packages wm)
  (gnu packages gtk)
  (gnu packages audio)
  (gnu packages version-control)
  (gnu packages package-management)
  (gnu packages file-systems)
  (gnu packages web-browsers)
  (gnu packages linux)

  (guix transformations)

  (srfi srfi-1)

  (nongnu packages linux)
  (nongnu system linux-initrd)
  (nongnu packages nvidia)
)
(use-service-modules desktop networking ssh xorg linux)
(use-package-modules fonts wm freedesktop linux xorg)

(define transform
  (options->transformation
    '((with-graft. "mesa=nvda"))))

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix")
  (users (cons* (user-account
                  (name "jb")
                  (comment "Jb")
                  (group "users")
                  (home-directory "/home/jb")
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video" "lp" "tty")))
                %base-user-accounts))

	(packages (append (map specification->package+output
	'("sbcl" "sbcl-stumpwm-ttf-fonts" "font-dejavu"
		"sbcl-clx" "sbcl-cl-ppcre" "sbcl-alexandria" "font-iosevka"
		"font-gnu-unifont" "stumpwm" "emacs" "alacritty" "openjdk"
    "bluez" "bluez-alsa" "pulseaudio" "blueman"
		"nss-certs" "arandr" "vim" "gvfs" "git" "nss-certs"))
		%base-packages-disk-utilities %base-packages))

  (kernel-arguments (append
                      '("modprobe.blacklist=nouveau")
                      %default-kernel-arguments))
  (kernel-loadable-modules (list nvidia-driver))

	;;(packages (append (list sbcl stumpwm `(,stumpwm "lib"))
		;;cl-clx cl-ppcre cl-alexandria
		;;emacs alacritty nss-certs arandr vim
		;;%base-packages))

  (services (cons*
              (simple-service 'custom-udev-rules udev-service-type
                (list nvidia-driver))
              (service kernel-module-loader-service-type '("ipmi_devintf" "nvidia" "nvidia_modeset" "nvidia_uvm"))
      (service slim-service-type
        (slim-configuration
          (xorg-configuration (xorg-configuration
                                (modules (cons* nvidia-driver %default-xorg-modules))
                                (server (transform xorg-server))
                                (drivers '("nvidia"))))
          (display ":0") (vt "vt1")))
      (service transmission-daemon-service-type)
      (service openssh-service-type)
      (bluetooth-service #:auto-enable? #t)

		;;(service kernel-module-loader-service-type
			;;'("ipmi_devintf" "nvidia" "nvidia-modset" "nvidia-uvm"))
		;;(simple-service 'custom-udev-rules udev-service-type (list nvidia-driver))

	;;(set-xorg-configuration
		;;(xorg-configuration
			;;(modules (cons* nvidia-driver %default-xorg-modules))
			;;(drivers '("nvidia"))))

		(modify-services %desktop-services
      (guix-service-type config => (guix-configuration
                                     (inherit config)
                                     (substitute-urls
                                       (append (list "https://substitutes.nonguix.org")
                                         %default-substitute-urls))
                                     (authorized-keys
                                       (append (list (local-file "./signing-key.pub"))
                                         %default-authorized-guix-keys))))
		(delete gdm-service-type))
		;;%base-services
		))

	;;(kernel-arguments (append
		;;'("modprobe.blacklist=nouveau")
		;;%default-kernel-arguments))

	;;(kernel-loadable-modules (list nvidia-driver))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices
    (list (uuid "2284922a-24b0-4cfa-8007-ca8a24f265a2")))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "902550b2-fc71-451c-ae91-9ba67753e404"
                     'btrfs))
	     (type "btrfs")
	     (options "subvol=root")
	     )
	   (file-system
             (mount-point "/boot")
             (device
               (uuid "902550b2-fc71-451c-ae91-9ba67753e404"
                     'btrfs))
	     (type "btrfs")
	     (options "subvol=boot")
	     )
	   (file-system
             (mount-point "/gnu")
             (device
               (uuid "902550b2-fc71-451c-ae91-9ba67753e404"
                     'btrfs))
	     (type "btrfs")
	     (options "subvol=gnu")
	     )
	   (file-system
             (mount-point "/home")
             (device
               (uuid "902550b2-fc71-451c-ae91-9ba67753e404"
                     'btrfs))
	     (type "btrfs")
	     (options "subvol=home")
	     )
	   (file-system
             (mount-point "/var/log")
             (device
               (uuid "902550b2-fc71-451c-ae91-9ba67753e404"
                     'btrfs))
	     (type "btrfs")
	     (options "subvol=log")
	     )
	   (file-system
             (mount-point "/data")
             (device
               (uuid "902550b2-fc71-451c-ae91-9ba67753e404"
                     'btrfs))
	     (type "btrfs")
	     (options "subvol=data")
	     )
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "2207-052D" 'fat32))
             (type "vfat"))
           %base-file-systems))

(name-service-switch %mdns-host-lookup-nss))
