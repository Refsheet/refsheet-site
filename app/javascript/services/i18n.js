/* global Refsheet */

import i18n from 'i18next'
import Backend from 'i18next-locize-backend'
import LngDetector from 'i18next-browser-languagedetector'
import moment from 'moment'

const detectionOptions = {
  order: ['querystring', 'cookie', 'localStorage', 'navigator', 'htmlTag'],
  lookupQuerystring: 'locale',
  lookupCookie: '_rst_lang',
}

i18n
  .use(LngDetector)
  .use(Backend)
  .init({
    saveMissing:
      typeof Refsheet !== 'undefined' && Refsheet.environment === 'development',
    fallbackLng: 'en',
    ns: ['common'],
    defaultNS: 'common',
    react: {
      useSuspense: false,
    },
    interpolation: {
      escapeValue: false,
    },
    backend: {
      projectId: '6ed4fe38-276a-4796-a6d4-59da84aaeaf9',
      apiKey: '1484d673-099c-4192-8fe6-8b54c4c3165c',
      referenceLng: 'en',
      allowedAddOrUpdateHosts: [
        'localhost',
        'dev.refsheet.net',
        'dev1.refsheet.net',
      ],
    },
    detection: detectionOptions,
  })

i18n.on('languageChanged', function (locale) {
  moment.locale(locale)
})

window.__I18N = i18n

export default i18n
