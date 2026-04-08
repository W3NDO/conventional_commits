# Used by "mix commit"
[
  required: [:scope, :body, :footer], # specifies the parts of a commit that must be included
  footer_fields: [:author, :reviewed_by, :refs], # specifies the required footer fields.
  breaking_change_in_footer: false # change to true if BREAKING CHANGE should be included in the footer.
]
