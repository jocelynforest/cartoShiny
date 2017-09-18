vuePropos =   navbarMenu('A propos', icon = icon("info"),
                         tabPanel('Version', icon = icon("code-fork"),
                                  includeMarkdown('./ressource/markdown/version.md')),
                         tabPanel('Licence', icon = icon("copyright"),
                                  includeMarkdown('./ressource/markdown/license.md'))
)