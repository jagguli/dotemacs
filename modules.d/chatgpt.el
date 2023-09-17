; fix the in the invocation of chatgpt-handle-response
(require 'url)
(require 'json)
(require 'cl)
(require 'password-store)


(defvar chatgpt-api-key
  (if (not (executable-find "pass"))
      "NOTSET"
    ;(password-store-get "dev/anyscale/api_key")))
    (password-store-get "internet/openai/apikey")))
(defvar chatgpt-api-endpoint
     ;;"https://api.endpoints.anyscale.com/v1/chat/completions")
     "https://api.openai.com/v1/chat/completions")
(defvar chatgpt-model
;;"meta-llama/Llama-2-7b-chat-hf")
"gpt-3.5-turbo")
(defun chatgpt-handle-response (response query)
  "Handle the ChatGPT API RESPONSE by displaying the raw response and parsed choices."
  ;; Save the raw response in a buffer named "chatgpt-raw".
  (with-output-to-temp-buffer "chatgpt-raw"
    (princ response)
    (switch-to-buffer-other-window "chatgpt-raw"))
  
  ;; Parse the JSON response and display the choices in a new buffer.
  (let ((json-object-type 'plist))
    (condition-case err
        (let* ((json-response (json-read-from-string response))
               (id (plist-get json-response :id))
               (result (plist-get json-response :choices)))
          ;; Rename the raw response buffer to "chatgpt-raw-{id}".
          (with-current-buffer "chatgpt-raw"
            (rename-buffer (format "chatgpt-raw-%s-%s" (format-time-string "%Y%m%d%H%M%S") id)))
          ;; Display the parsed choices in a buffer named "chatgpt-{id}".
          (with-output-to-temp-buffer (format "chatgpt-%s-%s" (format-time-string "%Y%m%d%H%M%S") id)
            (princ (plist-get (plist-get (elt result 0) :message) :content))
            (switch-to-buffer-other-window (format "chatgpt-%s-%s" (format-time-string "%Y%m%d%H%M%S") id))))
      
      ;; If there's an error during JSON parsing, rename the raw response buffer
      ;; to "chatgpt-error-{id}" and display an error message in "chatgpt-error".
      (error
       (with-current-buffer "chatgpt-raw"
         (rename-buffer (format "chatgpt-error-%s" (format-time-string "%Y%m%d%H%M%S"))))
       (with-output-to-temp-buffer "chatgpt-error"
         (princ (format "Error during JSON parsing: %s\n\nRaw response:\n\n%s" (error-message-string err) response))
         (switch-to-buffer-other-window "chatgpt-error"))))))

(defun chatgpt-save-buffers ()
  "Save all chatgpt buffers to the '~/chatgpt/logs' directory."
  (interactive)
  (let ((timestamp (format-time-string "%Y%m%d%H%M%S")))
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (string-match-p "^chatgpt-" (buffer-name))
          (let* ((default-directory (expand-file-name "~/chatgpt/logs"))
                 (query (substring-no-properties (replace-regexp-in-string "[^[:alnum:]]" "" query)))
                 (query-hash (substring (secure-hash 'sha256 query) 0 10))
                 (filename (format "%s-%s-%s" (buffer-name) query-hash timestamp)))
            (unless (file-exists-p default-directory)
              (make-directory default-directory t))
            (write-file filename t)))))))


(defun chatgpt-kill-buffers ()
  "Kill all existing chatgpt buffers created by the chatgpt-send-message function."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (string-match-p "^chatgpt-" (buffer-name))
        (kill-buffer buf)))))



(defun chatgpt-send-message (message)
  "Send a MESSAGE to the ChatGPT and collect the raw response in a new buffer."
  (interactive (list (buffer-substring (region-beginning) (region-end))))
  ;; Set up the API request details.
  (let ((url-request-method "POST")
        (url-request-extra-headers
         `(("Content-Type" . "application/json")
           ("Authorization" . ,(concat "Bearer " chatgpt-api-key))))
        (url-request-data
         (json-encode
          `(("model" . ,chatgpt-model)
            ("messages" . [((role . "user") (content . ,message))])))))
    ;; Make the API request.
    (url-retrieve
        chatgpt-api-endpoint
     (lexical-let ((captured-message message))
       (lambda (status)
         ;; Remove HTTP headers from the response.
         (goto-char (point-min))
         (re-search-forward "^$")
         (delete-region (point) (point-min))
         ;; Extract the response content.
         (let ((response (buffer-string)))
           (kill-buffer)
           ;; Call the response handling function.
           (chatgpt-handle-response response captured-message)))))))
