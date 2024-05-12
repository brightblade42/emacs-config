(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(set-face-attribute 'default nil :font "JetbrainsMono Nerd Font" :height 130)

(require 'package)
(require 'eglot)



(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("org"  . "https://orgmode.org/elpa/")
			 ))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;;initialuise use-package. don't think these checks are needed in emacs 29
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)



(use-package company
    :ensure t
    :init
    (global-company-mode t)
    :config
    (setq company-idle-delay 0.5
	company-minimum-prefix-length 2
	company-show-numbers t))




(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  )

;(use-package tree-sitter-langs
;  :after tree-sitter)
(setq treesit-language-source-alist
      '(
	(elixir "https://github.com/elixir-lang/tree-sitter-elixir")
	(heex "https://github.com/phoenixframework/tree-sitter-heex")
	(bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(use-package eglot
  :config
    (add-to-list 'eglot-server-programs
             '(elixir-mode "~/dev/lang-servers/elixir-ls/language_server.sh")))
  ;;;:config
  ;;(add-to-list 'eglot-server-programs '(elixir-mode  "/Users/ryan/dev/elixir-ls-v0.21.1/language_server.sh" )))

(use-package elixir-mode
  :config
  (add-hook 'elixir-mode-hook 'eglot-ensure))


(use-package web-mode
  :mode ("\\.heex\\'" . web-mode))






(use-package command-log-mode)


(use-package all-the-icons)
;;That doom aesthetic without the Doom
(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))



;;====== BEGIN MINI BUFFER ENHANCEMENTS =============

;;Modernizing the completions and minibuffer stuff
(use-package vertico
  :bind (:map vertico-map
	 ("C-j" . vertico-next)
	 ("C-k" . vertico-previous)
	 ("C-f" . vertico-exit)
	 :map minibuffer-local-map
	 ("M-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode 1))


;;embark

;;history will show up at the top of vertico lists
(use-package savehist
  :init
  (savehist-mode))

;;extra info in the margins of the mini buffer completions, very fancy
(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotator-light nil))
  :init
  (marginalia-mode))

;;if you use space seprated search, orderless will search in any order..  vert mod | mod vert will find vertico-mode
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult)


;;====== END MINI BUFFER ENHANCEMENTS =============

(use-package undo-fu)

;;MAKE IT EEEVIL VIM world baby
(use-package evil
  :demand t
  :bind
  (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ; use v motions so that word wrapped lines aren't skipped
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  )


(evil-define-key 'normal 'global (kbd "C-u") 'evil-scroll-up)
;;vim bindings outside the buffer, for binings everywhere. 
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;;transient keybindings
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "up")
  ("k" text-scale-decrease "down")
  ("f" nil "finished" :exit t))

;;keybinding goodness
(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer rlm/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rlm/leader-keys
    "t" '(:ignore t :which-key "toggles")
    "tt" '(consult-theme :which-key "choose theme")
    "ts" '(hydra-text-scale/body :which-key "scale text")
    "o" '(:ignore o :which-key "org")
    "oa" '(org-agenda :which-key  "agenda")
    "oc" '(org-capture :which-key  "capture")
    ))

;;better help UI
(use-package helpful
  :bind
  (("C-h f" . #'helpful-callable)
   ("C-h v" . #'helpful-variable)
   ("C-h k" . #'helpful-key)
   ("C-h x" . #'helpful-command)
   ("C-c C-d" . #'helpful-at-point)
   ))

;;project specific enhancements
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
    ("C-c p" . projectile-command-map)
    :init
    ;;(when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code" "~/dev"))
    (setq projectile-switch-project-action #'projectile-dired))

;;git UI genius
(use-package magit)

(defvar org-roam-base "~/org-roam/"
  "this is where our org-roam files go!")

(defvar org-base "~/org/"
  "this is where our regular org files go! Though I'm thinking everything belongs in org-roam")

(defvar eyemetric-todos (concat org-roam-base "eyemetric.org")
  "All of our eyemetric todos")


(use-package org
  :config
  (setq org-startup-indented t
	org-pretty-entities t
	org-use-sub-superscripts "{}"
	org-hide-emphasis-markers t
	org-startup-with-inline-images t
	org-agenda-files (list
			  eyemetric-todos
			   "~/org-roam/"
			   (concat org-roam-base "archive.org")
			   (concat org-base "personal.org"))
	org-default-notes-file "~/org/notes/notes.org"
	org-agenda-start-with-log-mode t
	org-log-done 'time
	org-log-into-drawer t
	org-image-actual-width '(300))
  (setq org-refile-targets
	'(("archive.org" :maxlevel . 1)
	  ("eyemetric.org"   :maxlevel . 2)))

  (setq org-todo-keywords
	'((sequence "TODO(t)" "STARTED(s)" "WAITING(w)" "|" "DONE(d!)")
	  (sequence "IDEA(i)" "PLAN(p)" "FUTURE(f)")))

  ;;not bad. we'll continue to work on it.  
  (setq org-capture-templates
	'(
	  ("t" "Tasks / Projects")
	  ("ti" "Inbox" entry (file+headline eyemetric-todos "Inbox")
	   "* TODO %?\n %a\n %i" :empty-lines  1)

	  ("ts" "Setup and Config" entry (file+headline eyemetric-todos "Setup and Configure")
	   "* TODO %?\n %i\n")

	  ("to" "Sex Offender" entry (file+headline eyemetric-todos "Sex Offender")
	   "* TODO %?\n %i\n")

	  ("te" "EyeFR" entry (file+headline eyemetric-todos "EyeFR")
	   "* TODO %?\n %i\n")
	  ))

  (setq org-agenda-custom-commands
	'(("i" "STARTED"
	   ((todo "STARTED" ((org-agenda-overriding-header "Todos Started")))))
	  ("d" "DONE"
	   ((todo "DONE" ((org-agenda-overriding-header "Todos DONE")))))

	  ("E" "EyeFR Tasks" tags-todo "+eye") ;;not used really
	  ))

  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  ;;doing that source code block magic
  (org-babel-do-load-languages
    'org-babel-load-languages
     '((emacs-lisp . t)
       (python . t)
       (shell . t)))

  ;;;stop annoying me with confirm prompts.
  (setq org-confirm-babel-evaluate nil)


  ) ;;end org

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))


(use-package org-roam
  :custom
  (org-roam-directory "~/org-roam/")
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(
     ("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)

     ("p" "project" plain
      (file "~/org-roam/templates/project_template.org")
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)

     ))
  :bind
  (("C-c n l" . org-roam-buffer-toggle)
   ("C-c n f" . org-roam-node-find)
   ("C-c n g" . org-roam-graph)
   ("C-c n i" . org-roam-node-insert)
   ("C-c n c" . org-roam-capture)
   ;; Dailies
   ("C-c n j" . org-roam-dailies-capture-today)
   ("C-M-i"   . completion-at-point))
:config
(org-roam-setup))


(define-key emacs-lisp-mode-map (kbd "C-x M-t") 'consult-theme)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons command-log-mode company consult doom-modeline
		   doom-themes elixir-mode evil-collection general
		   helpful hydra magit marginalia orderless
		   org-bullets org-roam projectile rainbow-delimiters
		   tree-sitter-langs undo-fu vertico web-mode
		   which-key)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
