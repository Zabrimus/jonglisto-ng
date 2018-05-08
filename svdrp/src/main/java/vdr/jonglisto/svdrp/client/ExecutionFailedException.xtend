package vdr.jonglisto.svdrp.client

@SuppressWarnings("serial")
class ExecutionFailedException extends RuntimeException {
    new(String cause) {
        super(cause)
    }
}
