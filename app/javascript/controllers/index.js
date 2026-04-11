import { application } from "./application"

import ClipboardController from "./clipboard_controller"
application.register("clipboard", ClipboardController)

import CooperativeController from "./cooperative_controller"
application.register("cooperative", CooperativeController)

import FeedbackController from "./feedback_controller"
application.register("feedback", FeedbackController)

import SupportController from "./support_controller"
application.register("support", SupportController)
