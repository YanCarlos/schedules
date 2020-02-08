import axios from 'axios';

const authenticity_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

class EventService {
  static create(values) {
    return axios({
      method: 'post',
      url:  '/events',
      data: { "event": values, 'authenticity_token': authenticity_token },
      headers: {
        'Content-Type': 'application/json',
      }
    })
    .then(response => {
      if (response.status !== 201) {
        return Promise.reject(response.response);
      }
    })
    .catch(error => {
      return Promise.reject(error.response);
    })
  }
}

export default EventService;
