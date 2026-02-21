import { Application } from "@hotwired/stimulus"
import PostFormController from "./post_form_controller"
import CommentFormController from "./comment_form_controller"
import PostController from "./post_controller"
import ReactionPickerController from "./reaction_picker_controller"
import FriendButtonController from "./friend_button_controller"
import FormValidationController from "./form_validation_controller"

const application = Application.start()

application.register("post-form", PostFormController)
application.register("comment-form", CommentFormController)
application.register("post", PostController)
application.register("reaction-picker", ReactionPickerController)
application.register("form-validation", FormValidationController)
application.register("friend-button", FriendButtonController)

export { application }
