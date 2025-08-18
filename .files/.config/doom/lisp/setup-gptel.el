;;; ../../.dotfiles/.files/.config/doom/lisp/setup-gptel.el -*- lexical-binding: t; -*-

;;; Code:
;; ---------------------------------------------------------
;; * gptel 核心配置
;; ---------------------------------------------------------
(after! gptel
  (auth-source-pass-enable)
  (setq-default
   gptel-backend (gptel-make-deepseek "DeepSeek"  ; 定义 DeepSeek 后端
                   :host "api.deepseek.com"
                   :key (lambda ()
                          (auth-source-pass-get 'secret "deepseek/api-emacs"))
                   :models '("deepseek-reasoner" "deepseek-chat")  ; 可选模型列表
                   :protocol "https"
                   :stream t)  ; 启用流式响应
   gptel-model 'deepseek-reasoner  ; 使用推理增强模型
   gptel-use-curl t
   gptel-display-buffer-action '(pop-to-buffer-same-window)
   gptel-include-reasoning "*thinking.org*"
   gptel-default-mode 'org-mode)


  (setf (alist-get 'org-mode gptel-prompt-prefix-alist) "*Prompt*: "
        (alist-get 'org-mode gptel-response-prefix-alist) "*Response*:\n"
        (alist-get 'markdown-mode gptel-prompt-prefix-alist) "#### ")

  ;; ========== 响应后处理 ==========
  ;; LaTeX 实时预览（仅限 Org mode）
  ;; (defun my/gptel-latex-preview (beg end)
  ;;   (when (derived-mode-p 'org-mode)
  ;;     (org-latex-preview--preview-region 'dvisvgm beg end)))
  ;; (add-hook 'gptel-post-response-functions #'my/gptel-latex-preview)
  (defun my/gptel-remove-headings (beg end)
    (when (derived-mode-p 'org-mode)
      (save-excursion
        (goto-char beg)
        (while (re-search-forward org-heading-regexp end t)
          (forward-line 0)
          (delete-char (1+ (length (match-string 1))))
          (insert-and-inherit "*")
          (end-of-line)
          (skip-chars-backward " \t\r")
          (insert-and-inherit "*")))))
  (add-hook 'gptel-post-response-functions #'my/gptel-remove-headings)

  ;; ========== 界面优化 ==========
  ;; 模型指示器（显示在 mode-line）
  (add-to-list 'mode-line-misc-info
               '(:eval (when (local-variable-p 'gptel-model)
                         (concat "[" (gptel--model-name gptel-model) "]"))))

  ;; === 预设配置 ===
  (gptel-make-preset 'default
    :description "DeepSeek 默认配置"
    :backend "DeepSeek"
    :stream t
    :system "你是一个生活在doom emacs中的大语言模型，用简洁准确的语句回答问题")

  (gptel-make-preset 'explain
    :description "深度解释模式"
    :include-reasoning nil
    :system "详细解释以下内容，包含技术原理和实用示例：")

  (gptel-make-preset 'code
    :description "代码专家模式"
    :include-reasoning nil
    :system "你是一个资深程序员，只返回可直接执行的代码，不包含解释")

  (gptel-make-preset 'translate
    :description "胖翻译"
    :system "将内容翻译为中文，如果是单词给出详细解释，如果是句子直接翻译"
    :include-reasoning nil)

  (gptel-make-preset 'gitcommit
    :description "生成git commite相关内容"
    :system "你是一个生活在doom emacs中的大语言模型，请用简洁的语言回答问题"
    :model 'deepseek-chat
    :include-reasoning nil)

  (gptel--apply-preset 'default)

  ;; ---------------------------------------------------------
  ;; * 实用功能扩展
  ;; ---------------------------------------------------------
  ;; === 快速问答侧边栏 ===
  (use-package! gptel-ask
    :bind (:map help-map
                ("C-q" . gptel-ask))
    :config
    (setf (alist-get "^\\*gptel-ask\\*" display-buffer-alist
                     nil nil #'equal)
          '((display-buffer-reuse-window display-buffer-in-side-window)
            (side . right) (slot . 10) (window-width . 0.3))))

  ;; ---------------------------------------------------------
  ;; * 项目集成
  ;; ---------------------------------------------------------
  ;; === 项目专属聊天文件 ===
  (defun my/gptel-project-chat ()
    "打开当前项目的聊天文件"
    (interactive)
    (let ((default-directory (project-root (project-current))))
      (find-file "Project_Chat.org")
      (gptel-mode 1)))
  (map! :map doom-leader-project-map "C-g" #'my/gptel-project-chat))

;; ---------------------------------------------------------
;; * tool and mcp
;; ---------------------------------------------------------
(use-package! llm-tool-collection
  :after gptel
  :config
  (mapcar (apply-partially #'apply #'gptel-make-tool)
          (llm-tool-collection-get-all)))

(provide 'setup-gptel)
;;; setup-gptel.el ends here
