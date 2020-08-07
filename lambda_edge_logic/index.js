exports.handler = (event, context, callback) => {
  const response = {
    status: "302",
    statusDescription: "Found",
    headers: {
      location: [
        {
          key: "Location",
          value: "https://nossbigg.github.io/aws-lambda-edge-redirect-example/",
        },
      ],
    },
  };
  callback(null, response);
};
