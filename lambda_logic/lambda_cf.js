exports.handler = (event, context, callback) => {
  console.log("## CONTEXT: " + serialize(context));
  console.log("## EVENT: " + serialize(event));

  const request = event.Records[0].cf.request;
  const headers = request.headers;

  const requestCountry = headers["cloudfront-viewer-country"][0].value;
  const countryCodeParam = `countryCode=${requestCountry}`;

  // CHANGEME to own website to redirect to
  const redirectUrl = `https://nossbigg.github.io/aws-lambda-edge-redirect-example/?${countryCodeParam}`;
  console.log(`lambda_cf: redirect to '${redirectUrl}'`);

  const response = {
    status: "302",
    statusDescription: "Found",
    headers: {
      location: [
        {
          key: "Location",
          value: redirectUrl,
        },
      ],
    },
  };
  callback(null, response);
};

const serialize = (object) => {
  return JSON.stringify(object, null, 2);
};
