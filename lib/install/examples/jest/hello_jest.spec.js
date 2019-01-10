import HelloJest from 'packs/hello_jest';

describe('HelloJest', () => {
  describe('#sum', () => {
    it('returns the correct sum', () => {
      const helloJest = new HelloJest(1,2);
      expect(helloJest.sum()).toEqual(3);
    });
  });
});
