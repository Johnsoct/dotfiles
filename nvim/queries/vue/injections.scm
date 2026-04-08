;extends

; <script lang="js">
((script_element
  (start_tag
    (attribute
      (attribute_name) @_setup)
    (attribute
      (attribute_name) @_lang
      (quoted_attribute_value
        (attribute_value) @_js)))
  (raw_text) @injection.content)
  (#eq? @_setup "setup")
  (#eq? @_lang "lang")
  (#eq? @_js "js")
  (#set! injection.language "javascript"))

; <script lang="ts">
((script_element
  (start_tag
    (attribute
      (attribute_name) @_setup)
    (attribute
      (attribute_name) @_lang
      (quoted_attribute_value
        (attribute_value) @_ts)))
  (raw_text) @injection.content)
  (#eq? @_setup "setup")
  (#eq? @_lang "lang")
  (#eq? @_ts "ts")
  (#set! injection.language "typescript"))

; <script lang="tsx">
; <script lang="jsx">
(script_element
  (start_tag
    (attribute
      (attribute_name) @_setup)
    (attribute
      (attribute_name) @_attr
      (quoted_attribute_value
        (attribute_value) @injection.language)))
  (#eq? @_setup "setup")
  (#eq? @_attr "lang")
  (#any-of? @injection.language "tsx" "jsx")
  (raw_text) @injection.content)
