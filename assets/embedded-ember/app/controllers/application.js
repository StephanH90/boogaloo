import Controller from '@ember/controller';

export default class IndexController extends Controller {
  field = {
    pk: 'foo',
    question: {
      raw: {
        hintText: 'a hint text rendered in a caluma component',
      },
    },
    errors: ['an error rendered in a caluma component'],
  };
}
