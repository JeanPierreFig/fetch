


### Summary: Include screen shots or a video of your app highlighting its features

![Simulator Screenshot](https://github.com/user-attachments/assets/8f3df74a-ad38-4c86-961e-fb8b6f79f9cd)

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I primarily focused on the network service and caching management. My goal was to ensure that the business logic was well-implemented and properly tested.  

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I mostly worked on this after work, spending approximately six hours in total.  

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

The main trade-off was keeping the UI simple to maximize my time on data caching logic, networking, and unit testing.  

### Weakest Part of the Project: What do you think is the weakest part of your project?

I kept the state management simple as well. I would say the weakest part is my simplified implementation of network error handling. Ideally, cached data should not be removed from the UI when displaying a network error.  

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

I disabled URL caching on the network source for demonstration purposes.

I created all the provided endpoints `EmptyEndpoint()`, `MalformedEndpoint()`, and the main endpoint `RecipesEndpoint()` to test them. You can change the `activeEndpoint` property in `RecipesMainViewModel`.
