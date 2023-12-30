function handler(event) {
    var request = event.request;
    return {
    statusCode: 301,
    headers: { location: { value: `https://example.com` } },
    };
  }
  