# Used by "mix commit"
[
  required: [:footer, :body], # specifies the parts of a commit that must be included
  scoped: true, # Specifies if the commit requires a scope, eg fix(parser)
  footer_fields: [:author, :reviewed_by, :refs] # specifies the required footer fields.
]
