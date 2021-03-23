import DOMPurify from 'dompurify'

export function sanitize(html) {
  return DOMPurify.sanitize(html, {
    ALLOWED_ATTR: ['style', 'class', 'type', 'href'],
    ALLOWED_TAGS: [
      'figure',
      'table',
      'caption',
      'thead',
      'tr',
      'th',
      'tbody',
      'td',
      'style',
    ],
  })
}
