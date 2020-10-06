exports.handler = (event, context, callback) => {
  console.log("## CONTEXT: " + serialize(context));
  console.log("## EVENT: " + serialize(event));

  const body = { context, event };
  console.log(`lambda_apigw: data = ${JSON.stringify(body)}`);

  const response = {
    status: 200,
    headers: {
      "Content-Type": "application/json",
    },
    body,
  };
  callback(null, response);
};

const serialize = (object) => {
  return JSON.stringify(object, null, 2);
};
