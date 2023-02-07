(setq user-full-name "Edward R. Klebanow"
      user-mail-address "klebane@outlook.com")
(setq fancy-splash-image "~/doom-vapourwave-grid.png")
(setq doom-theme 'leuven)
(setq doom-font (font-spec :family "JetBrains Mono" :size 16)
      doom-big-font (font-spec :family "JetBrains Mono" :size 26)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 16)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))
(setq-default
 delete-by-moving-to-trash t
 tab-width 4
 uniquify-buffer-name-style 'forward
 window-combination-resize t
 x-stretch-cursor t)
(show-smartparens-global-mode 1)
(setq undo-limit 80000000
      evil-want-fine-undo t
      auto-save-default t
      inhibit-compacting-font-caches t
      truncate-string-ellipsis "…"
      display-time-24hr-format t)

(setq auth-sources '("~/.authinfo.gpg"))
(delete-selection-mode 1)
(display-time-mode 1)
(display-battery-mode 1)
(global-subword-mode 1)
(setq-default major-mode 'org-mode)
(global-set-key "\C-cd" 'darkroom-tentative-mode)

(setq display-line-numbers-type 'visual)
(setq display-time-day-and-date t)

(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

(setq evil-vsplit-window-right t
      evil-split-window-below t)

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

;;(setq browse-url-browser-function 'browse-url-generic)
;;(setq browse-url-generic-program "qutebrowser")

  (setq mu4e-maildir (expand-file-name "~/Maildir/my-outlook")
        mu4e-get-mail-command "mbsync -a"
        mu4e-update-interval 600
        mu4e-index-update-in-background t
        mu4e-compose-signature-auto-include t
        mu4e-use-fancy-chars t
        mu4e-view-show-addresses t
        mu4e-view-show-images t
        mu4e-compose-format-flowed t
        mu4e-change-filenames-when-moving t
        mu4e-maildir-shortcuts
         '( ("/Inbox" . ?i)
            ("/Archive" . ?a)
            ("/Drafts" . ?d)
            ("/Deleted" . ?t)
            ("/Sent" . ?s))

         message-send-mail-function 'smtpmail-send-it
         message-signature-file "~/.signature_email"
         message-citation-line-format "On %a %d %b %Y at %R, %f wrote:\n"
         message-citation-line-function 'message-insert-formatted-citation-line
         message-kill-buffer-on-exit t)

(set-email-account! "klebane@outlook.com"
                    '((user-mail-address      . "klebane@outlook.com")
                      (user-full-name         . "Edward Klebanow")
                      (smtpmail-smtp-server   . "smtp-mail.outlook.com")
                      (smtpmail-smtp-service  . 587)
                      (smtpmail-stream-type   . starttls)
                      (smtpmail-debug-info    . t)
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-refile-folder     . "/Archive")
                      (mu4e-sent-folder       . "/Sent")
                      (mu4e-trash-folder      . "/Deleted")
                      (mu4e-update-interval   . 600)
                      )
                    nil)

(global-set-key "\C-cm" 'mu4e)


(setq mu4e-get-mail-command (format "INSIDE_EMACS=%s mbsync -a" emacs-version)
      epa-pinentry-mode 'ask)
(setq mu4e-bookmarks
      `(
	("flag:unread AND NOT flag:trashed" "Unread messages" ?u)
	("flag:unread" "Unread messages" ?n)
        ("date:today..now" "Today's messages" ?t)
        ))
(map!
 :after mu4e
 :map mu4e-view-mode-map
 "C-c u" #'bjm/mu4e-view-go-to-url-gui)

  (after! mu4e
  (add-to-list 'mu4e-view-actions '("browse message" .  mu4e-action-view-in-browser)))

(defun bjm/mu4e-view-go-to-url-gui ()
  "Wrapper for mu4e-view-go-to-url to use gui browser instead of eww"
  (interactive)
  (let ((browse-url-browser-function . browse-url-qutebrowser-program))
    (mu4e-view-go-to-url-gui)))
(setq mu4e-headers-results-limit '50)
(setq bookmark-default-file '"/home/eklebanow/bookmarks")
(defun mu4e-headers-mark-all-unread-read ()
  "Put a ! \(read) mark on all visible unread messages."
  (interactive)
  (mu4e-headers-mark-for-each-if
   (cons 'read nil)
   (lambda (msg _param)
     (memq 'unread (mu4e-msg-field msg :flags)))))

(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)

(add-hook 'mu4e-index-updated-hook
  (defun new-mail-sound ()
    (shell-command "aplay ~/sms.wav&")))
(setq alert-fade-time '10)

(after! elfeed
  (use-package elfeed-org
  :ensure t
  :config
(elfeed-org)
(setq elfeed-show-entry-switch 'display-buffer)
(setq rmh-elfeed-org-files (list "~/elfeed.org"))))


(after! elfeed
(setq browse-url-handlers '((".*youtube.*" . browse-url-xdg-open) ("." . eww-browse-url)))
(setq elfeed-feeds '("~/feeds.el"))
(global-set-key "\C-ce" 'elfeed-new-search))

(defun bjm/elfeed-show-visit-gui ()
  "wrapper for elfeed-show))-visit to use gui browser instead of eww"
  (interactive)
  (let ((browse-url-generic-program "qutebrowser"))
    (elfeed-show-visit t)))

(global-set-key (kbd "C-x w") 'elfeed)

(defun bjm/elfeed-show-all ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-all"))
(defun bjm/elfeed-show-tech ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-tech"))
(defun bjm/elfeed-show-news ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-news"))
(defun bjm/elfeed-show-science ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-science"))
(defun bjm/elfeed-show-YouTube ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-YouTube"))
(defun bjm/elfeed-show-sports ()
  (interactive)
  (bookmark-maybe-load-default-file)
  (bookmark-jump "elfeed-sports"))

(after! elfeed
  (set-face-attribute 'elfeed-search-unread-title-face
                      nil
                      :weight 'normal
                      :foreground (face-attribute 'default :foreground)))

(map!
 :after elfeed
 :map elfeed-search-mode-map
 "C-c a" #'bjm/elfeed-show-all
 "C-c t" #'bjm/elfeed-show-tech
 "C-c s" #'bjm/elfeed-show-sports
 "C-c y" #'bjm/elfeed-show-YouTube
 "C-c w" #'bjm/elfeed-show-science
 "C-c n" #'bjm/elfeed-show-news
 "C-c u" #'elfeed-update)

(after! elfeed
  (elfeed-goodies/setup)
  (setq elfeed-goodies/entry-pane-size 0.5)
  (add-hook 'elfeed-show-mode-hook 'visual-line-mode)
  (evil-define-key 'normal elfeed-show-mode-map
    (kbd "J") 'elfeed-goodies/split-show-next
    (kbd "K") 'elfeed-goodies/split-show-prev)
  (evil-define-key 'normal elfeed-search-mode-map
    (kbd "J") 'elfeed-goodies/split-show-next
    (kbd "K") 'elfeed-goodies/split-show-prev)
  (setq elfeed-goodies/tag-column-width 12)
  (setq elfeed-goodies/log-window-position 'bottom)
  (setq elfeed-goodies/log-window-size 0.8)
  (setq elfeed-goodies/powerline-default-separator 'arrow))

(defcustom eww-buffer-max-height 0.9
  "maximum height for the eww buffer window."
  :group 'eww
  :type 'integer)
(setq eww-buffer-max-height 0.1)

(after! circe
  (set-irc-server! "irc.us.libera.chat"
	    '(:tls t
	      :port 6697
	      :nick "klebane"
	      :sasl-username "klebane"
	      :sasl-password "dairycow"
	      :channels ("#gentoo"))))

(setq org-journal-enae-agenda-integration 't)
(setq org-hide-emphasis-markers t)
 (after! org
 (add-hook 'visual-line-mode-hook #'visual-fill-column-mode)
   (setq visual-fill-column-width 80)
   (setq-default visual-fill-column-center-text t))

 (global-set-key "\C-s" 'swiper)

 (after! flyspell (require 'flyspell-lazy) (flyspell-lazy-mode 1))

 (after! flyspell (add-hook 'text-mode-hook 'flyspell-mode))
    (setq ispell-program-name "hunspell")
    (setq ispell-dictionary "en_US")

 (global-set-key (kbd "<f12>") 'flyspell-correct-wrapper)

 (setq +org-capture-journal-file '"~/cal/journal.org")
 (after! org
   (setq org-startup-indented t)
   (setq org-superstar-headline-bullets-list '("⁖"))
   (setq org-agenda-files '("~/org/"))
   (setq org-odt-preferred-output-format "doc"))
(after! org
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
(setq org-auto-tangle-default t))

 (after! org
   (use-package! org-roam
     :init
     (setq org-roam-v2-ack t)
 ;
     (map! :leader
         :prefix "n"
         :desc "org-roam" "l" #'org-roam-buffer-toggle
         :desc "org-roam-node-insert" "i" #'org-roam-node-insert
         :desc "org-roam-node-find" "f" #'org-roam-node-find
         :desc "org-roam-ref-find" "r" #'org-roam-ref-find
         :desc "org-roam-show-graph" "g" #'org-roam-show-graph
         :desc "org-roam-capture" "c" #'org-roam-capture)
 :config
 (org-roam-setup)))

   (add-hook 'org-roam-mode-hook #'turn-on-visual-line-mode)
   (setq org-roam-capture-templates
         '(("d" "default" plain
            "%?"
            :if-new (file+head "${slug}.org"
                               "#+title: ${title}\n")
            :unnarrowed t)))
(use-package! org-roam-dailies
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam-dailies-capture-today" "j" #'org-roam-dailies-capture-today)
  :custom
  (org-roam-directory "~/RoamNotes")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-capture-templates
    '(("d" "default" entry "* %<%I:%M %p>: %?"
       :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         :map org-mode-map
         ("C-M-i" . completion-at-point)
         :map org-roam-dailies-map
         ("Y" . org-roam-dailies-capture-yesterday)
         ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies))

(use-package! org-download
  :after org
  :custom
  (org-download-image-dir "~/org/img/")
  (org-download-screenshot-method "scrot -s %s")
  (org-download-method 'directory)
  (org-download-screenshot-file "~/tmp/screenshot.png")
  (org-download-heading-lvl 1))

(map! :leader
      (:prefix ("v" . "vuiet")
       :desc "vuiet-stop" "s" #'vuiet-stop
       :desc "vuiet-next" "n" #'vuiet-next
       :desc "vuiet-previous" "p" #'vuiet-previous
       :desc "vuiet-replay" "r" #'vuiet-replay
       :desc "vuiet-play-loved-tracks" "l" #'vuiet-play-loved-tracks
       :desc "vuiet-play-loved-track" "tt" #'vuiet-play-loved-track
       :desc "vuiet-play-album" "a" #'vuiet-play-album
       :desc "vuiet-play-track-search" "ts" #'vuiet-play-track-search
       :desc "vuiet-play-track-lyrics" "tl" #'vuiet-playing-track-lyrics))

(eshell-git-prompt-use-theme 'powerline)

(map! :leader
      (:prefix ("d" . "dired")
       :desc "Open dired" "d" #'dired
       :desc "Dired jump to current" "j" #'dired-jump)
      (:after dired
       (:map dired-mode-map
        :desc "Peep-dired image previews" "d p" #'peep-dired
        :desc "Dired view file" "d v" #'dired-view-file)))

(evil-define-key 'normal dired-mode-map
  (kbd "M-RET") 'dired-display-file
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file ; use dired-find-file instead of dired-open.
  (kbd "m") 'dired-mark
  (kbd "t") 'dired-toggle-marks
  (kbd "u") 'dired-unmark
  (kbd "C") 'dired-do-copy
  (kbd "D") 'dired-do-delete
  (kbd "J") 'dired-goto-file
  (kbd "M") 'dired-do-chmod
  (kbd "O") 'dired-do-chown
  (kbd "P") 'dired-do-print
  (kbd "R") 'dired-do-rename
  (kbd "T") 'dired-do-touch
  (kbd "Y") 'dired-copy-filenamecopy-filename-as-kill ; copies filename to kill ring.
  (kbd "Z") 'dired-do-compress
  (kbd "+") 'dired-create-directory
  (kbd "-") 'dired-do-kill-lines
  (kbd "% l") 'dired-downcase
  (kbd "% m") 'dired-mark-files-regexp
  (kbd "% u") 'dired-upcase
  (kbd "* %") 'dired-mark-files-regexp
  (kbd "* .") 'dired-mark-extension
  (kbd "* /") 'dired-mark-directories
  (kbd "; d") 'epa-dired-do-decrypt
  (kbd "; e") 'epa-dired-do-encrypt)
;; Get file icons in dired
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; With dired-open plugin, you can launch external programs for certain extensions
;; For example, I set all .png files to open in 'sxiv' and all .mp4 files to open in 'mpv'
(setq dired-open-extensions '(("gif" . "sxiv")
                              ("jpg" . "sxiv")
                              ("png" . "sxiv")
                              ("mkv" . "mpv")
                              ("mp4" . "mpv")
                              ("pdf" . "evince")))

(evil-define-key 'normal peep-dired-mode-map
  (kbd "j") 'peep-dired-next-file
  (kbd "k") 'peep-dired-prev-file)
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)

(setq delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files/")

(setq dired-guess-shell-alist-user '(("\\.pdf$" "nohup xdg-open * </dev/null >/dev/null ()>&1 &")))

(setq engine/browser-function 'nyxt-browse-url)

(after! engine-mode

(defun my/start-and-connect-to-nyxt (&optional no-maximize)
  "Start Nyxt with swank capabilities."
  (interactive)
  (async-shell-command (format "nyxt -e \"(nyxt-user::start-swank)\""))
  (sleep-for my/slime-nyxt-delay)
  (my/slime-connect "localhost" "4006")
  (unless no-maximize (my/slime-repl-send-string "(toggle-fullscreen)")))

(defun my/slime-connect (host port)
  (defun true (&rest args) 't)
  (advice-add 'slime-check-version :override #'true)
  (slime-connect host port)
  (sleep-for my/slime-nyxt-delay)
  (advice-remove 'slime-check-version #'true))

(defun my/slime-repl-send-string (sexp)
  (defun true (&rest args) 't)
  (advice-add 'slime-check-version :override #'true)
  (if (slime-connected-p)
      (slime-repl-send-string sexp)
    (error "Slime is not connected to Nyxt. Run `my/start-and-connect-to-nyxt' first."))
  (sleep-for my/slime-nyxt-delay)
  (advice-remove 'slime-check-version #'true))

(defun my/browse-url-nyxt (url &optional buffer-title)
  (interactive "sURL: ")
  (my/slime-repl-send-string
   (format
    "(buffer-load \"%s\" %s)"
    url
    (if buffer-title (format ":buffer (make-buffer :title \"%s\")" buffer-title) ""))))

(defun browse-url-nyxt (url &optional new-window)
  (interactive "sURL: ")
  (unless (slime-connected-p) (my/start-and-connect-to-nyxt))
  (my/browse-url-nyxt url)))
(defengine amazon
  "https://www.amazon.com/s/ref=nb_sb_noss?field-keywords=%s")

(defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "d")

(defengine github
  "https://github.com/search?ref=simplesearch&q=%s")

(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  :keybinding "g")

(defengine google-images
  "http://www.google.com/images?hl=en&source=hp&biw=1440&bih=795&gbv=2&aq=f&aqi=&aql=&oq=&q=%s")

(defengine google-maps
  "http://maps.google.com/maps?q=%s"
  :docstring "Mappin' it up.")

(defengine stack-overflow
  "https://stackoverflow.com/search?q=%s")

(defengine twitter
  "https://twitter.com/search?q=%s")

(defengine wikipedia
  "http://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s"
  :keybinding "w"
  :docstring "Searchin' the wikis.")

(defengine wiktionary
  "https://www.wikipedia.org/search-redirect.php?family=wiktionary&language=en&go=Go&search=%s")

(defengine youtube
  "http://www.youtube.com/results?aq=f&oq=&search_query=%s")

(use-package vertico
  :ensure t
  :bind (:map vertico-map
         ("C-j" . vertico-next)
         ("C-k" . vertico-previous)
         ("C-f" . vertico-exit)
         :map minibuffer-local-map
         ("M-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

(with-eval-after-load 'ox-latex
(add-to-list 'org-latex-classes
             '("org-plain-latex"
               "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))
(setq org-latex-toc-command "\\tableofcontents \\clearpage")

(beacon-mode t)

 (setq vundo-compact-display t)

 ;; Better contrasting highlight.
 (custom-set-faces
   '(vundo-node ((t (:foreground "#808080"))))
   '(vundo-stem ((t (:foreground "#808080"))))
   '(vundo-highlight ((t (:foreground "#FFFF00")))))

  ;; Use `HJKL` VIM-like motion, also Home/End to jump around.
 ;; (define-key vundo-mode-map (kbd "l") #'vundo-forward)
 ;; (define-key vundo-mode-map (kbd "<right>") #'vundo-forward)
 ;; (define-key vundo-mode-map (kbd "h") #'vundo-backward)
 ;; (define-key vundo-mode-map (kbd "<left>") #'vundo-backward)
 ;; (define-key vundo-mode-map (kbd "j") #'vundo-next)
 ;; (define-key vundo-mode-map (kbd "<down>") #'vundo-next)
 ;; (define-key vundo-mode-map (kbd "k") #'vundo-previous)
 ;; (define-key vundo-mode-map (kbd "<up>") #'vundo-previous)
 ;; (define-key vundo-mode-map (kbd "q") #'vundo-quit)
 ;; (define-key vundo-mode-map (kbd "C-g") #'vundo-quit)
 ;; (define-key vundo-mode-map (kbd "RET") #'vundo-confirm)

(with-eval-after-load 'evil (evil-define-key 'normal 'global (kbd "C-M-u") 'vundo))

(yas-global-mode 1)
