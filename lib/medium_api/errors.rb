module MediumApi
  class Error < StandardError
    UnauthorizedError = Class.new(MediumApi::Error)
    BadRequestError = Class.new(MediumApi::Error)
    ForbiddenError = Class.new(MediumApi::Error)
  end
end
