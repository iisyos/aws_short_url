import cf from "cloudfront";

const kvsId = "${kvs_id}";

// This fails if the key value store is not associated with the function
const kvsHandle = cf.kvs(kvsId);

async function handler(event) {
  var request = event.request;
  // Use the first part of the pathname as key, for example http(s)://domain/<key>/something/else
  const key = event.request.uri.split("/")[1];
  try {
    const value = await kvsHandle.get(key);
    return {
      statusCode: 301,
      headers: { location: { value } },
    };
  } catch (err) {
    console.log(err.message);
  }
  return request;
}
