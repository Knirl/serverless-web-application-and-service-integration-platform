

// API Gateway endpoint
const API_URL = "https://00vsph4f6g.execute-api.ap-southeast-1.amazonaws.com";


// GET /requests
const getRequests = async () => {
  const response = await fetch(`${API_URL}/requests`);

  if (!response.ok) {
    throw new Error("Failed to load requests");
  }

  return await response.json();
};


// GET /requests/{id}
const getRequest = async (id) => {
  const response = await fetch(`${API_URL}/requests/${encodeURIComponent(id)}`); //Send a request to our API Gateway /requests endpoint and wait here until the response arrives.

  if (!response.ok) {                       //If the response was NOT successful (! = NOT)
    if (response.status === 404) {
      throw new Error("Request not found");
    }

    throw new Error("Failed to load request");
  }

  return await response.json();  //Wait for the JSON body, turn it into a JavaScript object, and give that object back to whoever called getRequests().
};


// POST /requests
const createRequest = async (data) => {
  const response = await fetch(`${API_URL}/requests`, {
    method: "POST",

    headers: {
      "Content-Type": "application/json"
    },

    body: JSON.stringify(data)
  });

  if (!response.ok) {
    throw new Error("Failed to create request");
  }

  return await response.json();
};


// PUT /requests/{id}
const updateRequest = async (id, data) => {
  const response = await fetch(`${API_URL}/requests/${encodeURIComponent(id)}`, {
    method: "PUT",

    headers: {
      "Content-Type": "application/json"
    },

    body: JSON.stringify(data)
  });

  if (!response.ok) {
    if (response.status === 404) {
      throw new Error("Request not found");
    }

    throw new Error("Failed to update request");
  }

  return await response.json();
};


// DELETE /requests/{id}
const deleteRequest = async (id) => {
  const response = await fetch(`${API_URL}/requests/${encodeURIComponent(id)}`, {
    method: "DELETE"
  });

  if (!response.ok) {
    if (response.status === 404) {
      throw new Error("Request not found");
    }

    throw new Error("Failed to delete request");
  }

  return await response.json();
};