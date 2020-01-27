import 'babel-polyfill'
import Adapter from 'enzyme-adapter-react-16'
import Chai from 'chai'
import chaiEnzyme from 'chai-enzyme'
import Enzyme from 'enzyme'

Enzyme.configure({ adapter: new Adapter() })
Chai.use(chaiEnzyme())

// function to require all modules for a given context
let requireAll = requireContext => {
  requireContext.keys().forEach(requireContext)
}

// require all js files except testHelper.js in the test folder
requireAll(require.context('./', true, /^((?!specHelper).)*\.(jsx?|coffee)$/))

// require all js files except main.js in the src folder
requireAll(
  require.context(
    '../../app/javascript/',
    true,
    /^((?!application).)*\.(jsx?|coffee)$/
  )
)
