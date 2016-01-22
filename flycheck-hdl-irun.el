;;; flycheck-hdl-irun.el --- Support Cadence irun in flycheck

;; Copyright (C) 2016 Colin Marquardt <colin@marquardt-home.de>
;;
;; Author: Colin Marquardt <colin@marquardt-home.de>
;; Created: 21 January 2016
;; Version: 0.2
;; Package-Requires: ((flycheck "0.25"))

;;; Commentary:

;; This package adds support for Cadence irun
;; (http://www.cadence.com/products/fv/enterprise_simulator/pages/default.aspx)
;; to flycheck.  To use it, add something like the following your init.el:

;; (require 'flycheck-hdl-irun)
;; (add-hook 'vhdl-mode-hook 'flycheck-mode)
;; (add-hook 'verilog-mode-hook 'flycheck-mode)
;; (add-hook 'systemc-mode-hook 'flycheck-mode)
;; (setq flycheck-hdl-irun-hdlvar
;;   (concat (getenv "PRJ_HOME") "/env/df2/hdl.var"))

;;; License:

;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(require 'flycheck)

(flycheck-def-config-file-var flycheck-hdl-irun-hdlvar
    hdl-irun "hdl.var")
(flycheck-def-config-file-var flycheck-hdl-irun-cdslib
    hdl-irun nil)

(flycheck-define-checker hdl-irun
  "A checker for hardware description languages (HDLs) using Cadence irun.
irun is part of the Cadence Incisive Enterprise Simulator
(http://www.cadence.com/products/fv/enterprise_simulator/pages/default.aspx)."
  :command ("irun" "-compile"
            (config-file "-hdlvar" flycheck-hdl-irun-hdlvar)
            (config-file "-cdslib" flycheck-hdl-irun-cdslib)
            source)
  :error-patterns
  ((info line-start (one-or-more (in "a-z"))
         ": *I," (id (one-or-more (in "A-Z0-9"))) " (" (file-name) "," line "|" column "): "
         (message) line-end)
   (warning line-start (one-or-more (in "a-z"))
            ": *W," (id (one-or-more (in "A-Z0-9"))) " (" (file-name) "," line "|" column "): "
            (message) line-end)
   (error line-start (one-or-more (in "a-z"))
          (or ": *E," ": *F,") (id (one-or-more (in "A-Z0-9"))) " (" (file-name) "," line "|" column "): "
          (message) line-end))
  :modes (systemc-mode vhdl-mode verilog-mode))

(add-to-list 'flycheck-checkers 'hdl-irun)

(provide 'flycheck-hdl-irun)
;;; flycheck-hdl-irun.el ends here
